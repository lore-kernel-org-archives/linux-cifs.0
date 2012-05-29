From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 0/7] transport/session code move to ops struct
Date: Tue, 29 May 2012 18:34:18 +0400
Message-ID: <CAKywueQEi7uZ8zjjV3uKf31zzzrUqo2k40tpCrhJ9-ZTtJ5zTQ@mail.gmail.com>
References: <1338197414-22340-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338197414-22340-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/28 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> This is the regular patchset that makes the existing cifs code work t=
hrough
> ops struct of the server.
>
> The version #2 consists the S_OP code that makes the code execution s=
afer.
>
> Pavel Shilovsky (7):
> =A0CIFS: Introduce S_OP/S_OPV macros for a safe access to ops struct
> =A0 =A0field
> =A0CIFS: Move get_next_mid to ops struct
> =A0CIFS: Move trans2 processing to ops struct
> =A0CIFS: Extend credit mechanism to process request type
> =A0CIFS: Move protocol specific negotiate code to ops struct
> =A0CIFS: Move protocol specific session setup/logoff code to ops stru=
ct
> =A0CIFS: Move protocol specific tcon/tdis code to ops struct
>
> =A0fs/cifs/cifsglob.h =A0| =A0 60 +++++++++--
> =A0fs/cifs/cifsproto.h | =A0 12 +--
> =A0fs/cifs/cifssmb.c =A0 | =A0 28 +++---
> =A0fs/cifs/connect.c =A0 | =A0236 +++++++----------------------------=
-------
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 89 +----------------
> =A0fs/cifs/sess.c =A0 =A0 =A0| =A0 =A05 +-
> =A0fs/cifs/smb1ops.c =A0 | =A0290 +++++++++++++++++++++++++++++++++++=
+++++++++++++++-
> =A0fs/cifs/transport.c | =A0 47 +++++----
> =A09 files changed, 423 insertions(+), 346 deletions(-)
>

Let's consider this version invalid - will repost soon.

--=20
Best regards,
Pavel Shilovsky.
