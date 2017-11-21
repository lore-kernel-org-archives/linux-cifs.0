From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] CIFS: decrease log level of smb2 DFS error
Date: Tue, 21 Nov 2017 14:48:26 +0100
Message-ID: <87zi7fspxx.fsf@suse.com>
References: <20171121111429.14496-1-aaptel@suse.com> <CAN05THRymsFpZcbXsSQj6=OVd94ZWE1L5a1EQF5-bz8qbG=oFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN05THRymsFpZcbXsSQj6=OVd94ZWE1L5a1EQF5-bz8qbG=oFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> Since in 99.999999% times happens just because "it is a real share",
> we could optionally change it instead to be wrapped in :
>
> if (rc != <whatever STATUS_NOT_FOUND maps to>)
>      cifs_dbg(VFS, log the error message
>
> so that we do not log anything if it is just a normal share
> but that we do log something if there is a real error.

Good idea

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
