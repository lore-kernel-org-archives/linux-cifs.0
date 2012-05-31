From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v4 1/7] CIFS: Add safe access to is_valid_oplock and
 dump_detail ops struct field
Date: Thu, 31 May 2012 16:53:16 +0400
Message-ID: <CAKywueTT7Dv-Qk9de_HR-v_+SVrZH-Hkfgp5SU5dpzGkjzyKqQ@mail.gmail.com>
References: <1338468657-29742-1-git-send-email-pshilovsky@samba.org>
	<1338468657-29742-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338468657-29742-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/31 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A06 ++++--
> =A01 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccafded..3647b1a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1058,13 +1058,15 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry !=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!mid_entry->multiR=
sp || mid_entry->multiEnd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->callback(mid_entry);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!server->ops->is_oplock_brea=
k(buf, server)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!server->ops->is_oplock_brea=
k ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!server->ops->is=
_oplock_break(buf, server)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "No task to =
wake, unknown frame received! "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
NumMids %d", atomic_read(&midCount));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_mem("Receive=
d Data is: ", buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0HEADER_SIZE(server));
> =A0#ifdef CONFIG_CIFS_DEBUG2
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ops->dump_detai=
l(buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->ops->dump_d=
etail)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>ops->dump_detail(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_mids(server)=
;
> =A0#endif /* CIFS_DEBUG2 */

Ops - forgot to remove this old version from the directory before send
patches to the list. The right one is "[PATCH v4 1/7] CIFS: Make
accessing is_valid_oplock/dump_detail ops struct field safe".

--=20
Best regards,
Pavel Shilovsky.
