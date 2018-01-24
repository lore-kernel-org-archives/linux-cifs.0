From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: manpage: update mount.cifs manpage with info about echo_interval option.
Date: Wed, 24 Jan 2018 11:40:01 +0100
Message-ID: <87y3knsfpa.fsf@suse.com>
References: <CAA_-hQJ=DsbeVWU7mr-W0sTRiPXnCC3vznmznQwBedQLtE0s_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA_-hQJ=DsbeVWU7mr-W0sTRiPXnCC3vznmznQwBedQLtE0s_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In practice I've noticed that we actually wait for twice the
echo_interval value to reconnect (/me has been doing a lot of
reconnection tests lately).

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
