From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 00/19] cifs: remove rfc1002 header from all smb2 requests
Date: Wed, 08 Nov 2017 15:38:47 +0100
Message-ID: <87r2t8j0nc.fsf@suse.com>
References: <20171102070312.18903-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Ronnie,

The patch looks good I think but I ran the xfstests test suite and after
applying your patches on top of Steve's for-next the generic/089 test
runs forever (10+ hours at full CPU usage after which I just hit ^C and
the program stopped) vs couple of seconds before. I'm not sure what's
going on here but since sending SIGINT stops the program its probably
not a kernel deadlock.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
