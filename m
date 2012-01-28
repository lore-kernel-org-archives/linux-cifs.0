From: Jeff Layton <jlayton@redhat.com>
Subject: how to handle failed writes in the middle of a set?
Date: Sat, 28 Jan 2012 06:44:22 -0500
Message-ID: <20120128064422.5d5e4022@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The SMB protocol specifies that if you don't have an oplock then writes
and reads to/from the server are not supposed to use the cache. Currently
cifs does this sort of write serially. I'd like to change it to do them
in parallel for better performance, but I'm not sure what to do in the
following situation:

Suppose we have a wsize of 64k. An application opens a file for write
and does not get an oplock. It sends down a 192k write from userspace.
cifs breaks that up into 3 SMB_COM_WRITE_AND_X calls on the wire,
fires them off in parallel and waits for them to return. The first and
third write succeed, but the second one (the one in the middle) fails
with a hard error.

How should we return from the write at that point? The alternatives I
see are:

1/ return -EIO for the whole thing, even though part of it was
successfully written?

2/ pretend only the first write succeeded, even though the part
afterward might have been corrupted?

3/ do something else?

-- 
Jeff Layton <jlayton@redhat.com>
