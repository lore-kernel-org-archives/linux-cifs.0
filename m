From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: directio read/write cleanups
Date: Fri, 11 Mar 2011 08:10:36 +0300
Message-ID: <AANLkTim0h03PVHxVkrVchL7EzuxNigwVGwkcBqhh5DJg@mail.gmail.com>
References: <1299751865-2741-1-git-send-email-piastry@etersoft.ru>
	<AANLkTikKr9Zkn0oD1DK=PN23QFR2wRg4UXh90mky+d36@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikKr9Zkn0oD1DK=PN23QFR2wRg4UXh90mky+d36-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/11 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Seems useful/promising - any informal before/after performance data.
> Do you expect it to affect performance?

I didn't measure a performance but only because I don't expect any
performance affect of this changes. It seems to me more like a cleanup
of this code part.

-- 
Best regards,
Pavel Shilovsky.
