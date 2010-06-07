From: Scott Lovenberg <scott.lovenberg@gmail.com>
Subject: Re: [PATCH] accept all supported values for
	dir_mode
Date: Mon, 7 Jun 2010 00:20:14 -0400
Message-ID: <AANLkTinPR8Mx_AIi59hgTJt-W8zqSg4mqSm0pWpVhFrF@mail.gmail.com>
References: <1275547159-30008-1-git-send-email-scott.lovenberg@gmail.com>
	<20100606073303.365579f5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1945125555421896137=="
Cc: linux-cifs@vger.kernel.org, linux-cifs-client@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-cifs-client-bounces@lists.samba.org>
In-Reply-To: <20100606073303.365579f5@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/linux-cifs-client>
List-Post: <mailto:linux-cifs-client@lists.samba.org>
List-Help: <mailto:linux-cifs-client-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=subscribe>
Sender: linux-cifs-client-bounces@lists.samba.org
Errors-To: linux-cifs-client-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

--===============1945125555421896137==
Content-Type: multipart/alternative; boundary=0015176f115e557a66048868fdd3

--0015176f115e557a66048868fdd3
Content-Type: text/plain; charset=UTF-8

>
> > -     if (strncmp(token, "dir_mode", 8) == 0)
> > +     if (strncmp(token, "dir_mode", 4) == 0 || strncmp(token, "dirm", 4)
> == 0)
>                                       ^^^^
> Sigh. But I can confirm that this is similarly broken in the kernel
> so we have little choice but to live with it here.
>
> That's exactly how I felt about this fix.  Do you have any feelings on
fixing this on both sides to accept only the full strings?  It might cause
regressions for people, so the kernel patch will probably be pulled by
Redhat, Suse and Debian (and anyone else backporting kernel patches for long
term releases) maintainers.
It seems like the right thing to do, but if it's just going to cause extra
work and be yanked either way... well, that's one step forward, two
backwards.


-- 
Peace and Blessings,
-Scott.

--0015176f115e557a66048868fdd3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;"><div class=3D"im=
">&gt; - =C2=A0 =C2=A0 if (strncmp(token, &quot;dir_mode&quot;, 8) =3D=3D 0=
)<br>
&gt; + =C2=A0 =C2=A0 if (strncmp(token, &quot;dir_mode&quot;, 4) =3D=3D 0 |=
| strncmp(token, &quot;dirm&quot;, 4) =3D=3D 0)<br>
</div> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^<br>
Sigh. But I can confirm that this is similarly broken in the kernel<br>
so we have little choice but to live with it here.<br>
<div class=3D"im"><br></div></blockquote><div>That&#39;s exactly how I felt=
 about this fix. =C2=A0Do you have any feelings on fixing this on both side=
s to accept only the full strings? =C2=A0It might cause regressions for peo=
ple, so the kernel patch will probably be pulled by Redhat, Suse and Debian=
 (and anyone else backporting kernel patches for long term releases) mainta=
iners. =C2=A0</div>
<div>It seems like the right thing to do, but if it&#39;s=C2=A0just going t=
o cause extra work and be yanked either way... well, that&#39;s one step fo=
rward, two backwards.</div></div><br clear=3D"all"><br>-- <br>Peace and Ble=
ssings,<br>
-Scott.<br><br>

--0015176f115e557a66048868fdd3--

--===============1945125555421896137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-cifs-client mailing list
linux-cifs-client@lists.samba.org
https://lists.samba.org/mailman/listinfo/linux-cifs-client

--===============1945125555421896137==--
