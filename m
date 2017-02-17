From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Fri, 17 Feb 2017 19:37:48 +0100
Message-ID: <mpsfujchddv.fsf@aaptelpc.suse.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de> <mps60keik2w.fsf@aaptelpc.suse.de> <066cc0b2-0e63-8cf6-7d46-578e524cf3bf@fbihome.de> <mpszihohiad.fsf@aaptelpc.suse.de> <1a130ab9-84bf-82cb-8c23-e071c286822c@fbihome.de> <mpswpcrhaet.fsf@aaptelpc.suse.de> <461c47b3-a4ae-c21c-26c5-b33dd19f2b37@fbihome.de> <41c29ddb-eafa-dc03-ab2b-864919aa4192@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <41c29ddb-eafa-dc03-ab2b-864919aa4192-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have reproduced the issue and can confirm your latest patch fixes it.

Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
