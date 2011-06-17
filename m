From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Fri, 17 Jun 2011 04:54:21 +0100
Message-ID: <20110617035421.GO11521@ZenIV.linux.org.uk>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
 <20110609124043.GA9621@infradead.org>
 <BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
 <20110611094314.GA6217@infradead.org>
 <20110611111253.GD11521@ZenIV.linux.org.uk>
 <BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Jun 11, 2011 at 06:00:25PM +0400, Pavel Shilovsky wrote:
> 2011/6/11 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
> > On Sat, Jun 11, 2011 at 05:43:14AM -0400, Christoph Hellwig wrote:
> >
> >> Ok, if we look at sb-private data in the sget callsbacks it seems like
> >> the clreanup for those does indeed need to be done in ->kill_sb. ?I have
> >> to say I really hate it, and the culprit is that we call the sget test
> >> callback is called before we call grab_super in sget, that is we don't
> >> protect against filesystems going away. ?I suspect that is the real
> >> problem here.
> >
> > grab_super() is *heavy* and having to undo it even once means that we need to
> > rescan. ?Sorry, test() has to be callable without that.
> >
> 
> In this case, I think we should follow NFS strategy and apply my patch
> as a workaround. Thoughts?

See #untested in vfs-2.6.git; I *hope* I've got all the leaks in current
mainline plugged and all sget() races ought to be taken care of.  And
yes, the branch name matches the reality - this sucker is completely
untested.  Have fun...  Commit message is atrocious, of course - I'm too
tired to even try writing a coherent patch description at the moment and
I'll probably need to split it into several patches anyway.  Tomorrow...
