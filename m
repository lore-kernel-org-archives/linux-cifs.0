From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: RE: tcon and session refcounts, get/put
Date: Mon, 15 Jan 2018 11:12:44 +0100
Message-ID: <873737a0rn.fsf@suse.com>
References: <876086apmw.fsf@suse.com> <DM5PR2101MB09361C20BD140B6E02B2C426B6170@DM5PR2101MB0936.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DM5PR2101MB09361C20BD140B6E02B2C426B6170-uvswG4RmAWieOSyIubIsYpz2gl+EIwcenBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> writes:
> But this tcon already has its own reference to smb ses. So, our reference to smb ses is useless because we doesn't create a new tcon which should hold the reference. So, that's why we drop our reference. At the end we have 1 tcp ses referenced by 1 smb ses referenced by 1 tcon referenced by 2 mounts.

Much clearer now, thanks Pavel!

> We probably need a comment describing this behavior, so, an appropriate patch is highly welcomed.

I will do that.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
