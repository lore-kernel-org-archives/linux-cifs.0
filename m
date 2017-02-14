From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Tue, 14 Feb 2017 17:02:50 +0100
Message-ID: <mpszihohiad.fsf@aaptelpc.suse.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de> <mps60keik2w.fsf@aaptelpc.suse.de> <066cc0b2-0e63-8cf6-7d46-578e524cf3bf@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <066cc0b2-0e63-8cf6-7d46-578e524cf3bf-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org> writes:
> I also had a look at the CIFS code and the tcon->tid member is just used
> to set the SMB2 header TreeId field or is set from the the SMB2 header
> TreeId field. If tcon structs are reused, I couldn't see a code path to
> zero it.

wasn't thinking of the reconnection, good catch!

I'm still not sure why you got the stacktrace on the old kernel. I'll
try it out.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
