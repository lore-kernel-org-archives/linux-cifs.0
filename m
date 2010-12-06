From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode (try #4)
Date: Mon, 6 Dec 2010 11:41:02 +0300
Message-ID: <AANLkTi=bFAYodYOsCkOx=aoP3+heipsbr2=cBqCSCGXg@mail.gmail.com>
References: <1291103671-2983-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291103671-2983-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/30 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Add cifs_file_aio_read where we read from the cache if we have at least
> Level II oplock - otherwise read from the server.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

What's about this?

-- 
Best regards,
Pavel Shilovsky.
