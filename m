From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Tue, 14 Feb 2017 17:39:39 +0100
Message-ID: <1a130ab9-84bf-82cb-8c23-e071c286822c@fbihome.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de>
 <mps60keik2w.fsf@aaptelpc.suse.de>
 <066cc0b2-0e63-8cf6-7d46-578e524cf3bf@fbihome.de>
 <mpszihohiad.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpszihohiad.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 14.02.2017 um 17:02 schrieb Aurélien Aptel:
> Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org> writes:
>> I also had a look at the CIFS code and the tcon->tid member is just used
>> to set the SMB2 header TreeId field or is set from the the SMB2 header
>> TreeId field. If tcon structs are reused, I couldn't see a code path to
>> zero it.
> 
> wasn't thinking of the reconnection, good catch!
> 
> I'm still not sure why you got the stacktrace on the old kernel. I'll
> try it out.

The trace starts with

[ 1815.635294] WARNING: CPU: 1 PID: 65 at
/tmp/cifs-3.13.0-100.147-patched/smb2pdu.c:164
small_smb2_init+0x246/0x560 [cifs]()

which is the place of the WARN call in my code. Since I also had a patch
for a newer kernel (Ubuntu 16.04 HWE for 14.04 AKA Linux 4.4), the
offsets are wrong in the attached patch.

I just re-checked my code. I didn't test the non-WARN variant and
assumed the code simply got inlined, so the function name is wrong.

Jan-Marek
