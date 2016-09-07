From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Fix regression which breaks DFS mounting
Date: Wed, 07 Sep 2016 18:22:37 +0200
Message-ID: <mpstwdrr86q.fsf@suse.com>
References: <1473164554-8062-1-git-send-email-sprabhu@redhat.com> <mps1t0wswyh.fsf@suse.com> <1473238975.3882.39.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha1; protocol="application/pgp-signature"
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473238975.3882.39.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Sachin,

Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> This is hit in Netapp because it returns SMB_SHARE_IS_IN_DFS even after
> the DFS node is resolved and the node returned doesn't contain a DFS
> share. Other servers(tested with MS Win2012 R2) do not and hence do not
> face this problem. A workaround for Netapp servers is to mount with the
> nodfs flag.

The issue I'm describing is happening on samba servers. Server A has 2
DFS links to server B. First link is pointing the the root of a share,
second link is pointing to a subdir of the same share. mounting A share
and trying to ls or cd in these links result in both pointing to the
root of the share B.

> I have a patch similar to your second variant which we have
> successfully tested in our lab and is currently undergoing user
> testing. I'll post it separately as soon as we have the results for
> that.
>
> In my opinion, the patch at the head of the thread here is not related
> to this problem and should go in ASAP to fix a regression which affects
> all DFS mounts.

Agreed. I can confirm that this patch lets me mount
//SERVER/share/dfs-main where dfs-main is a DFS link. I was previously
getting:

mount error(22): Invalid argument

Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>

=2D-=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJX0D7RAAoJEDIGO5Hchq/8m/UP/1en4pe2J/jbekYUKM+OKUZK
q3QXDaM72wOzxb7hIXJdMYJRm9W7tT+XFsaGHAeLaeKD0T2W3v8ks/28AEcVEUYG
sXXu8wrm0+0WHFkDDpuPypW25xn3+1QK7ffRnudoVHpAjA6quuVbalVyT5bF41Y/
ydqD5xTkq3V6shEpWfCfy/CwqB90M+IFsnIFbkph0YHFBh19zHaQeodZ4fD9l+0Y
6ggDLrVP/nwwriYlAIJFPfWp1VQdjlogudWzisi0mAON372mTvzyfVSUcaG3AlC0
tCqrx0buuLz21YhEDUQeapf4/7Xew7CsIIPlugJ1JPaxAl72djFi758BREqbgmQH
hsNyOmkgTq8zaSeeJOS3CbKFxBiJzg5MFGm6ai63lrkMBz1/GMhBmr7gLM9yl1hX
0/LXHVT6nXFM4rQxHIKR9l0W6lS33f+rCVSPYFMxxyHDpv8Qv5TyuDPLDqbGZJe5
tPIXN/7t3dHn1enrBYl/0LRBF1m9LEEZvI141SJ1Lh0tCPqfnw3VUDSO831gU4Gw
DpeBdmg6ENdolXPv7mijLRQPGKI/LIKQeVMN1U2LC3BlrhNT/a//BSGfwbPrLUBK
wYCorfKDxkChz1ieSQexFKd313raY27AB1j+jDLVE974yNLEFESocLJXA0XU6q/P
XxLCBEcEFVUQUiavcZga
=rNnV
-----END PGP SIGNATURE-----
--=-=-=--
