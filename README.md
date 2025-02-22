# Open-source Discord-like messaging app

This is a project I'm doing to learn Elixir and get better at distributed programming in general. The goal is to create a 
Discord-like messaging experience (with text only for now). If I wind up having the free time, I'll work in attachments and eventually
voice and video calls. Obviously, not affiliated with Discord in any way.

## Scratchpad Notes
These are just my personal notes.

### Basic requirements:
1. Users need to authenticate.
2. Users need to be able to manage their profile data. For now, avatars will be user-inputted URLs to image files.
3. Users will be able to create channels. For the sake of simplicity, all "servers" will just be one channel. So, "server" and "channel" are not separate concepts like in Discord, but are rather used interchangeably.
4. Users will be able to send messages to channels as well as directly to other users. DM's will always be 1:1, so users needing groups will need to make a channel.
5. When a user's session is active, they need to be receiving all messages sent to them in real-time.
6. When a user leaves and logs back in later, they need all of their conversations updated so they see every message that they missed.
7. Each channel's creator is the singular mod. They will be the only one with permission to add users, remove users, change the channel name, or delete the channel.
8. For the sake of simplicity, there are no "friends". Users are added or DM's directly by a unique username.
9. Historical messages will be paginated in some way. For now, I'll keep it simple with something like 100 messages at a time.

### Possible future requirements:
1. Real profile photos and message attachments.
2. Full user-relations management, with friendship and blocking.
3. Full moderation, with creators being allowed to appoint mods.

### Consistency
When a user updates their name/avatar, I want their name and icon to be updated on all new pulls of old conversations. I think this is a reasonable trade-off between
consistency and performance.

In order to do this, all data related to users will refer to users by profile ID. When data needs to be pulled related to those users, they will be fetched from
the user profiles service. This may sound bad, but we only need to pull once per user per request at most. For example, when loading all of a user's old conversations (as would be done on a fresh login on a new device), there will only be one hit to the user service for each person they've talked to within the bounds of the first page of their recent conversations. 

Granted, this is possibly still a lot of profiles, maybe up to 50-100 profiles for users who are frequently on busy channels. Howver, user profiles will be cached, which reduces the time to get each profile. If we can fetch a cached profile from Redis in .5 milliseconds (which is slow for Redis), the profile fetching can be done in 50 milliseconds for our highest load users. While that isn't exceptionally fast, it's often considered reasonable for an app to take 1-5 whole seconds to load upon a fresh login. From a UX perspective, this can be fixed with a cool loading animation.

### Storage
#### Messages DB
Probably Cassandra. Since users will be sending messages all the time, I need something that can handle massive write scale. Will need to optimize for reading messages
by channel/conversation and filtering by timestamp. So, a `chat_id` or `conversation_id` will probably be the partition key.

#### User Profile DB
TBD. However, this going to get a massive amount of reads considering how I want to handle historical consistency, so probably Mongo.

#### Channels DB
Will be read-heavy (channels are accessed far more often than created/updated). I'm thinking MongoDB with replication. I want to store a list of users
inside each channel document, so I need the flexibility of a document DB.


### Caching

#### User Profiles
It's going to be extremely important to cache these. I was originally thinking Redis, but I may look into Memcached since performance is critical here. Since profiles are only updated by users, the profile service can invalidate the caache. I'm also thinking a sliding TTL might be the right move here.