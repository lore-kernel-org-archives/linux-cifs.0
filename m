From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: SMB2: Enforce sec= mount option
Date: Wed, 11 Jan 2017 11:46:36 +0100
Message-ID: <mpsvatlj2lv.fsf@suse.com>
References: <1481179577-15995-1-git-send-email-sprabhu@redhat.com> <58756A3D.6000705@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: L A Walsh <law-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58756A3D.6000705-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

L A Walsh <law-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> writes:
> I'm not sure about the symbols, exactly, but I know in samba I
> ask for smb2 for the protocol and more often than not, only
> get smb1, but I'd rather have it work than fail.

About this specific thing: I believe smbclient negotiate the highest
protocol version it can (according to the min/max protocol version set
in its conf) whereas cifs.ko always uses smb1 by default (which is
probably against the spec).

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
