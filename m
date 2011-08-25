From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add uid/gid to SID mapping functions (try #4)
Date: Thu, 25 Aug 2011 06:44:29 -0500
Message-ID: <CADT32eLLx1dkjiaUpnPxzcTaBqtoo-0p_hPXLHjQtT9KLw2utw@mail.gmail.com>
References: <1312918260-23780-1-git-send-email-shirishpargonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312918260-23780-1-git-send-email-shirishpargonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 9, 2011 at 2:31 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Add functions to map a uid and gid to a SID. =A0These functions are
> similar to SID to uid and gid mapping functions.
> A SID is what is returned to the cifs module.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0cifs.idmap.c | =A0 37 +++++++++++++++++++++++++++++++++++++
> =A01 files changed, 37 insertions(+), 0 deletions(-)
>
> diff --git a/cifs.idmap.c b/cifs.idmap.c
> index 56edb58..80802d7 100644
> --- a/cifs.idmap.c
> +++ b/cifs.idmap.c
> @@ -134,6 +134,43 @@ cifs_idmap(const key_serial_t key, const char *k=
ey_descr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cifs_idmap_ret;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 sidstr =3D strget(key_descr, "oi:");
> + =A0 =A0 =A0 if (sidstr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid =3D atoi(sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "SID: %s, uid: %d", s=
idstr, uid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcUidToSid(uid, &sid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "uid =
%d to SID =A0error: %d", uid, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to a =
uid */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantia=
te(key, &sid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct wbcDomainSid), 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_ERR, "%s: key inst: %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, strerror(errno));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_idmap_ret;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sidstr =3D strget(key_descr, "gi:");
> + =A0 =A0 =A0 if (sidstr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid =3D atoi(sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "SID: %s, gid: %d", s=
idstr, gid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcGidToSid(gid, &sid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "gid =
%d to SID error: %d", gid, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to a =
gid */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantia=
te(key, &sid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct wbcDomainSid), 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_ERR, "%s: key inst: %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, strerror(errno));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_idmap_ret;
> + =A0 =A0 =A0 }
> +
> +
> =A0 =A0 =A0 =A0syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
>
> =A0cifs_idmap_ret:
> --
> 1.6.0.2
>
>

Jeff, any comments on this? I think this patch and kernel parts
of this patchset, should be doing similar to what is done currently
for server that support unix extensions.
A care is taken so that only the server ids can be assigned as
an id to change to, if an id can't be resolved, then chown/chgrp fail
and if an id can be resolved, the server is the one which whether
to apply the changed security descriptor or not.

Regards,

Shirish
