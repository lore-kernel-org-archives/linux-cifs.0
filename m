From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Mon, 20 Jun 2011 17:15:16 +0100
Message-ID: <20110620161516.GU11521@ZenIV.linux.org.uk>
References: <20110609124043.GA9621@infradead.org>
 <BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
 <20110611094314.GA6217@infradead.org>
 <20110611111253.GD11521@ZenIV.linux.org.uk>
 <BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
 <20110617035421.GO11521@ZenIV.linux.org.uk>
 <20110617140833.GA9563@ZenIV.linux.org.uk>
 <BANLkTi=mH-9F9N4Gz8JJqL==Hm5p8Y1_tQ@mail.gmail.com>
 <20110620085943.6371af1b@corrin.poochiereds.net>
 <BANLkTinfETnDdcBFkQNq8pLZPQOGsVRuGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinfETnDdcBFkQNq8pLZPQOGsVRuGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 20, 2011 at 11:13:22AM -0500, Steve French wrote:
> Would the plan be for Al to merge these out of his tree?

Can do, if cifs folks are OK with it...  Note that it's a regression since
the last merge window, so it probably ought to go to Linus before 3.0-final.
