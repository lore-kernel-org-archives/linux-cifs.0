From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Fri, 17 Jun 2011 15:08:33 +0100
Message-ID: <20110617140833.GA9563@ZenIV.linux.org.uk>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
 <20110609124043.GA9621@infradead.org>
 <BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
 <20110611094314.GA6217@infradead.org>
 <20110611111253.GD11521@ZenIV.linux.org.uk>
 <BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
 <20110617035421.GO11521@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110617035421.GO11521-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 17, 2011 at 04:54:21AM +0100, Al Viro wrote:

> See #untested in vfs-2.6.git; I *hope* I've got all the leaks in current
> mainline plugged and all sget() races ought to be taken care of.  And
> yes, the branch name matches the reality - this sucker is completely
> untested.  Have fun...  Commit message is atrocious, of course - I'm too
> tired to even try writing a coherent patch description at the moment and
> I'll probably need to split it into several patches anyway.  Tomorrow...

Updated, split up, pushed into #untested.  Enjoy...
