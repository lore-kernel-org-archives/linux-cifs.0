From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: CIFS backporting for kernel 2.6, SMB2/3 dialect support
Date: Thu, 19 Oct 2017 11:09:04 +0200
Message-ID: <mpsh8uvtsgf.fsf@aaptelpc.suse.de>
References: <DB6PR0301MB237377DF7009AFA00637913B944D0@DB6PR0301MB2373.eurprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Chris Davies <chris.davies-fcHNbCilqsSHXe+LvDLADg@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB6PR0301MB237377DF7009AFA00637913B944D0-TBqkY70YY8SewmrBc2YCyciOivS/YiWQnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Chris,

Chris Davies <chris.davies-fcHNbCilqsSHXe+LvDLADg@public.gmane.org> writes:
> Hi folks, I'm hoping to achieve SMB2.0+ dialect support for CentOS 6 clients (currently with CIFS 1.68).  Has anyone done a backport of newer CIFS versions for use in production? Was it trivial?

According to wikipedia CenOS 6 is based on kernel 2.6.32. This is
*old*. Adding SMBv2 support required large refactoring efforts and
kernel APIs are often changing so I expect backporting to be very hard
unfortunately.

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
