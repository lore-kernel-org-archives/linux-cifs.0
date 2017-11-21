From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 00/19 Version 4] cifs: remove rfc1002 from smb2 requests
Date: Tue, 21 Nov 2017 12:15:38 +0100
Message-ID: <873757ubl1.fsf@suse.com>
References: <20171121000442.24888-1-lsahlber@redhat.com> <CAKywueTabn0mDuagWUq5h4ByN_UszFZtpy4d5H_cy1qfEPZHEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTabn0mDuagWUq5h4ByN_UszFZtpy4d5H_cy1qfEPZHEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> Aurelien, a lot of error messages like "CIFS VFS: ioctl error in
> smb2_get_dfs_refer rc=-2" are being written into syslog. What do you
> think about decreasing the log level of this message?

Sure, I've sent a patch.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
