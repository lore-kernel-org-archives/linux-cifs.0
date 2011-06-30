From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v2 PATCH 0/5] Simplify demultiplex thread
Date: Thu, 30 Jun 2011 19:06:50 +0400
Message-ID: <BANLkTi=e+teJrGK2NVJn_=joMpTyz0aVEg@mail.gmail.com>
References: <1308908881-22760-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308908881-22760-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/24 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This patchset is going to make demultiplex code smaller and let us in=
tergrate SMB2 protocol support easier further.
>
> I successfully tested it with Connectathon Testsuites and two paralle=
l mount/umount scripts.
>
> This is the 2nd version of the patchset that includes the following c=
hanges:
> 1) Christoph's notes.
> 2) Fix comment style.
>
> Pavel Shilovsky (5):
> =A0CIFS: Move buffer allocation to a separate function
> =A0CIFS: Simplify socket reading in demultiplex thread
> =A0CIFS: Move RFC1002 check to a separate function
> =A0CIFS: Move mid search to a separate function
> =A0CIFS: Cleanup demupltiplex thread exiting code
>
> =A0fs/cifs/connect.c | =A0630 ++++++++++++++++++++++++++++-----------=
--------------
> =A01 files changed, 331 insertions(+), 299 deletions(-)
>
>

What's about this patchset?

--=20
Best regards,
Pavel Shilovsky.
