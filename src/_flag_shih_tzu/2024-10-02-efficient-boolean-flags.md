---
layout: post
title: "Efficient Boolean Flags with flag_shih_tzu"
date: 2024-10-02 13:45:00 +0000
---

Store multiple boolean flags efficiently in a single integer column with flag_shih_tzu.

## Why Use Bit Flags?

Instead of creating multiple boolean columns, store all flags in one integer:

- Save database space
- Faster queries
- Cleaner schema
- Better performance

## Setup

Add to your Gemfile:

```ruby
gem 'flag_shih_tzu'
```

## Define Flags

```ruby
class User < ActiveRecord::Base
  include FlagShihTzu
  
  has_flags 1 => :active,
            2 => :admin,
            3 => :verified,
            4 => :premium,
            column: 'flags'
end
```

## Usage

```ruby
user = User.new
user.active = true
user.admin = true
user.save

# Query users
User.active
User.admin
User.not_verified

# Check flags
user.active?      # => true
user.verified?    # => false

# Set multiple flags
user.flags = [:active, :verified, :premium]
```

## Database Migration

```ruby
class AddFlagsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :flags, :integer, default: 0, null: false
  end
end
```

## Advanced Features

- Named scopes for each flag
- Flag combinations
- Default values
- SQL optimizations

Perfect for managing user permissions and settings!
