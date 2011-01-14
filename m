From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: remove extraneous calls to d_set_d_op
Date: Fri, 14 Jan 2011 08:12:54 -0500
Message-ID: <20110114081254.7ca9e688@tlielax.poochiereds.net>
References: <1295007776-32329-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1295007776-32329-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 14 Jan 2011 07:22:56 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> Testing with the connectathon tests caused this panic:
> 
> [  388.266918] ------------[ cut here ]------------
> [  388.267823] kernel BUG at fs/dcache.c:1358!
> 
> [...]
> 
> [  388.267823] RIP: 0010:[<ffffffff81129146>]  [<ffffffff81129146>] d_set_d_op+0x10/0x58
> 
> [...]
> 
> [  388.267823] Call Trace:
> [  388.267823]  [<ffffffffa0147a3c>] cifs_create+0x5cd/0x6fe [cifs]
> [  388.267823]  [<ffffffff81123c5d>] vfs_create+0x70/0x91
> [  388.267823]  [<ffffffff8112499d>] do_last+0x15a/0x2ff
> [  388.267823]  [<ffffffff81124e41>] do_filp_open+0x2ff/0x6db
> [  388.267823]  [<ffffffff8110ca5f>] ? kmem_cache_free+0x76/0xb4
> [  388.267823]  [<ffffffff81464c6b>] ? _cond_resched+0xe/0x22
> [  388.267823]  [<ffffffff81229300>] ? might_fault+0x21/0x23
> [  388.267823]  [<ffffffff81229400>] ? __strncpy_from_user+0x1f/0x4e
> [  388.267823]  [<ffffffff8112eb70>] ? alloc_fd+0x74/0x11f
> [  388.267823]  [<ffffffff81118808>] do_sys_open+0x60/0xf2
> [  388.267823]  [<ffffffff810992e3>] ? audit_syscall_entry+0x11c/0x148
> [  388.267823]  [<ffffffff811188ba>] sys_open+0x20/0x22
> [  388.267823]  [<ffffffff811188e4>] sys_creat+0x15/0x17
> [  388.267823]  [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b
> [  388.436446] ---[ end trace a012e6143ebad719 ]---
> 
> The problem is that d_op is already set during the lookup. d_set_d_op
> will BUG() if you try to set operations when they have already been set.
> 
> Remove all of the d_set_d_op calls except for during lookups and ensure
> that it gets set on every lookup.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/dir.c   |   32 +++++++-------------------------
>  fs/cifs/inode.c |    9 ---------
>  fs/cifs/link.c  |    9 ++-------
>  3 files changed, 9 insertions(+), 41 deletions(-)
> 

Looks like Al's most recent changes should fix this already. I got this
panic on a kernel based on a pull earlier in the day.

Please just ignore this patch. Sorry for the noise!
-- 
Jeff Layton <jlayton@redhat.com>
