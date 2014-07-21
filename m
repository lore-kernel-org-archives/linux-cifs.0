From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Mon, 21 Jul 2014 13:43:12 -0500
Message-ID: <CAH2r5mtLO9jwBx+EumbXzEjiprPMVvnz39CsZJsEm3dAraDDZQ@mail.gmail.com>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
 <20140718170952.GA27001@samba2> <CAH2r5mubvLEd7QFY8p-YSCojPPdwzQMXK_Ka6k7V0uKRgUeeaw@mail.gmail.com>
 <20140719051427.GA21226@jeremy-HP> <CAH2r5mvSEYbGxE166W2GijnhKj4hVcVzhVLJQQeQeWejk4AoaQ@mail.gmail.com>
 <20140721182840.GC29893@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140721182840.GC29893@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What about shrinking the file to the wrong size?

On Mon, Jul 21, 2014 at 1:28 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sun, Jul 20, 2014 at 11:47:53PM -0500, Steve French wrote:
>> wireshark trace sent to jra
>
> "strict allocate = true" not set in the smb.conf,
> so bug report isn't useful :-). No fallocate
> calls will be made by smbd unless strict allocate
> is set.
>
> This might explain the problem (in case anyone
> else is tracking :-).



-- 
Thanks,

Steve
