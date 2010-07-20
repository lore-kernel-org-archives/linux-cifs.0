From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH 04/09] cifs: define superblock-level cache index objects
 and register them
Date: Tue, 20 Jul 2010 08:53:27 -0400
Message-ID: <20100720085327.4d1bf9d7@tlielax.poochiereds.net>
References: <Yes>
	<1278333747-30651-1-git-send-email-sjayaraman@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
	David Howells <dhowells@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1278333747-30651-1-git-send-email-sjayaraman@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon,  5 Jul 2010 18:12:27 +0530
Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Define superblock-level cache index objects (managed by cifsTconInfo structs).
> Each superblock object is created in a server-level index object and in itself
> an index into which inode-level objects are inserted.
> 
> The superblock object is keyed by sharename. The UniqueId/IndexNumber is used to
> validate that the exported share is the same since we accessed it last time.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Hmm...Steve started merging these already but I've just now had the
chance to review them.

This approach may be a problem. It seems to make the assumption that
there is only a single tcon per superblock. How exactly will this work
when there are multiple tcons per superblock as will be the case with
multisession mounts?

By having a cache cookie per tcon, will that mean that you'll
potentially have multiple versions of cached inodes (one for each tcon)?

-- 
Jeff Layton <jlayton@samba.org>
