From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: PROBLEM: CIFS SMB2/SMB3 does not work for domain based DFS
Date: Tue, 18 Jul 2017 17:09:23 +0200
Message-ID: <mpslgnl3hp8.fsf@aaptelpc.suse.de>
References: <F303188D30C85B49969BE73949AA0F8C6F171F0DF0@EXCHANGE.totemo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Totemo Support <support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F303188D30C85B49969BE73949AA0F8C6F171F0DF0-Xnr6BND5kcg95swH8otnYdHuzzzSOjJt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Totemo,

Totemo Support <support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org> writes:
> From my point of view it looks like there is no resolution attempt of resolving the domain based UNC (//domain.dev.com/files) into the actual dfsroot representation.
>
> Since my domain controller doesn't host the dfsroot structure, any attempts resolving on it directly will fail.
>
> I tried initially with Kernel 4.11 but also build a recent 4.13 with the same issues.
> Latest keyutils (/sbin/key.dns_resolver) are in place and configured on the system.
>
> Do you need any further scripts/explanations how I set up the test servers? It's nothing special, everything sticks to the defaults.

Could you open a bug report here [1] and provide network traces of you
mounting with smb1 and another one of you mounting with smb3 (add them
as attachement).

Thanks

1: https://bugzilla.samba.org/buglist.cgi?component=kernel%20fs&product=CifsVFS&resolution=---

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
