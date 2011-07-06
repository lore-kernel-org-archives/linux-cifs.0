From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v2 PATCH 0/5] Simplify demultiplex thread
Date: Wed, 6 Jul 2011 14:28:40 +0400
Message-ID: <CAKywueRkhXfGB794EWZfrPRmK=2Zhe=Ac3Qk6jYx9ip95SUMBA@mail.gmail.com>
References: <1309948059-29704-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309948059-29704-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry - wrong subject.

2011/7/6 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This patchset is going to make demultiplex code smaller and let us in=
tergrate SMB2 protocol support easier further.
>
> I successfully tested it with Connectathon Testsuites and two paralle=
l mount/umount scripts.
>
> This is the 3rd version of the patchset that includes bufixes for pat=
ch #4.
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



--=20
Best regards,
Pavel Shilovsky.
