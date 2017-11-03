From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add SendReceive3
Date: Fri, 3 Nov 2017 06:36:26 -0700
Message-ID: <20171103133626.GA4280@infradead.org>
References: <20171102070312.18903-1-lsahlber@redhat.com>
 <20171102070312.18903-2-lsahlber@redhat.com>
 <20171103062715.GB8075@infradead.org>
 <CAN05THS8m9Z=KwiGarKh4qJT-X_ZnYU_AqVe26NNtF3Ad9j5nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAN05THS8m9Z=KwiGarKh4qJT-X_ZnYU_AqVe26NNtF3Ad9j5nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 03, 2017 at 04:37:59PM +1000, ronnie sahlberg wrote:
> Since this will now be the _only_ send/receive function SMB2 uses
> (except for the two async calls)
> I can rename it s/SendReceive3/SMB2SendReceive/  ?

smb2_send_recv, please.

> > Also please explain the strategy for phasing out the old API(s) so
> > that we won't have three around forever.
> 
> That is harder and I don't plan to do so.
> SendReceive2 and SendReceiveNoRsp is after this series no longer used by
> smb2, but they are still used by SMB1.
> SMB1 uses a LOT of different send/receive functions.
> 
> 
> I don't want to touch SMB1. I mostly want it to just go away :-)

Oh well.  I guess it's just going to slowly bitrot then..
