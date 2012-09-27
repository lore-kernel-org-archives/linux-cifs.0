From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix possible freed pointer dereference in CIFS_SessSetup
Date: Thu, 27 Sep 2012 12:17:58 +0400
Message-ID: <CAKywueS=V4=rVGtersG=N34qHx=SXEvum9mRNGEzX+h+ZAE92g@mail.gmail.com>
References: <1348556409-10339-1-git-send-email-piastry@etersoft.ru>
	<1348556409-10339-2-git-send-email-piastry@etersoft.ru>
	<CAH2r5mtosT4Ws0ChJsmxjyoDikvFhoq8ANNg+=AAFDk+UnrRxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtosT4Ws0ChJsmxjyoDikvFhoq8ANNg+=AAFDk+UnrRxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/9/27 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> merged into cifs-2.6.git (along with the other two in this

What do you think about Cc'ing it to stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org as well?

-- 
Best regards,
Pavel Shilovsky.
