From: aaptel-IBi9RG/b67k@public.gmane.org (=?utf-8?Q?Aur=C3=A9lien?= Aptel)
Subject: smbcmp: new tool to compare SMB traces
Date: Tue, 31 Jan 2017 14:13:00 +0100
Message-ID: <mpspoj3jrtv.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I've written a small utility to diff and compare SMB network
captures. It's a simple python script that uses tshark to filter and
dissect SMB packets, with a curses UI.

https://github.com/aaptel/smbcmp

There is a gif demo on there, if you're into that.

Enjoy,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
