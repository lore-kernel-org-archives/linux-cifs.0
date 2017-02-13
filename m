From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Mon, 13 Feb 2017 09:14:15 +0100
Message-ID: <mps60keik2w.fsf@aaptelpc.suse.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25f3edd0-3abf-f541-d7f8-54ae1dbac081-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jan-Marek,

Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org> writes:
> I'm having problems with CIFS connections to our NAS. The vendor
> inspected the problem and claimed the Linux CIFS module doesn't follow
> the specifications, which causes the instabilities + shutdown problems
> with our LiMux clients in our SMB2+ tests.
>
> Quoting http://msdn.microsoft.com/en-us/library/cc246529.aspx:
>
> "TreeId (4 bytes): Uniquely identifies the tree connect for the
> command. This MUST be 0 for the SMB2 TREE_CONNECT Request."
>
> I applied the attached "warn" diff, which resulted in the (expected)
> following stack trace (albeit for an old Ubuntu kernel), but otherwise
> fixes the problem.

I looks like the tid should be initialized to 0 already. Could you
provide a network trace of the problem happening? See [1] if you need
help.

1: https://wiki.samba.org/index.php/Capture_Packets

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
