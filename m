From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Sat, 11 Jun 2011 05:43:14 -0400
Message-ID: <20110611094314.GA6217@infradead.org>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
 <20110609124043.GA9621@infradead.org>
 <BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> one of these two processes process umount call. So, it comes to
> cifs_put_super, calls cifs_umount and then calls kfree(cifs_sb).  In
> the same time, another process comes into cifs_do_mount and calls
> sget(). Then it appers into cifs_match_super that thinks that all
> structures like server, ses, tcon and cifs_sb are valid, but it is not
> true - the first process has already freed them but didn't remove
> superblock from fs_supers list.
> 
> So, I simply reodered calls: now umount codepath marks a superblock as
> non-active and calls kill_sb(new cifs_kill_super), it calls
> kill_anon_super (that calls cifs_put_super and removes superblock from
> fs_supers list) and after that kill_sb frees all cifs structures
> (server, ses, tcon, cifs_sb).
> 
> As the result, when we get into cifs_match_super (in mount from
> another process) we are sure that all cifs structures are valid.
> 
> If I am not right, correct me, please!

Ok, if we look at sb-private data in the sget callsbacks it seems like
the clreanup for those does indeed need to be done in ->kill_sb.  I have
to say I really hate it, and the culprit is that we call the sget test
callback is called before we call grab_super in sget, that is we don't
protect against filesystems going away.  I suspect that is the real
problem here.

The workaround you've copied from NFS also works, but it's pretty
ugly, given that ->kill_sb also is called for partially set up
superblocks.
