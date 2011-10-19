From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add uid/gid to SID mapping functions (try #3)
Date: Wed, 19 Oct 2011 13:13:23 -0500
Message-ID: <CADT32eK=G4-S+V1Sc0C5+NuO43oat9u3+GmW2gCSK-gp-ZMCYQ@mail.gmail.com>
References: <1312911245-22404-1-git-send-email-shirishpargonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312911245-22404-1-git-send-email-shirishpargonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 9, 2011 at 12:34 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
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

Hi Jeff, would you consider this patch for a possible merge?
The corrosponding kernel code has been merged in 3.2.
in Steve's git repository.

Regards,

Shirish
