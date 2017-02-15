From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Wed, 15 Feb 2017 14:05:14 +0100
Message-ID: <mpswpcrhaet.fsf@aaptelpc.suse.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de> <mps60keik2w.fsf@aaptelpc.suse.de> <066cc0b2-0e63-8cf6-7d46-578e524cf3bf@fbihome.de> <mpszihohiad.fsf@aaptelpc.suse.de> <1a130ab9-84bf-82cb-8c23-e071c286822c@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1a130ab9-84bf-82cb-8c23-e071c286822c-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org> writes:
> which is the place of the WARN call in my code. Since I also had a patch
> for a newer kernel (Ubuntu 16.04 HWE for 14.04 AKA Linux 4.4), the
> offsets are wrong in the attached patch.
>
> I just re-checked my code. I didn't test the non-WARN variant and
> assumed the code simply got inlined, so the function name is wrong.

I've just realized WARN() itself dumps the stacktrace and that your first
email said "expected" (not "unexpected")... *sigh* I was tired that day.

The reconnect logic is a bit convulted but patching where you did seems
correct. Calling smb2_reconnect with the Tree Connect command will reset
the Tid. Calling it with any command other command will end up calling
smb2_reconnect again with the Tree Connect.

    smb2_reconnect(cmd, ...)
      if (cmd == SMB2_TREE_CONNECT)
          TID = 0, return
      else    
          SMB2_tcon()
            small_smb2_init(SMB2_TREE_CONNECT, ...)
              smb2_reconnect(SMB2_TREE_CONNECT, ...)

I think its clearer and more explicit if we reset the Tid everytime we
send a Tree Con request. So in SMB2_tcon(), before the SendReceive2().

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
