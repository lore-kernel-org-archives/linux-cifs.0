From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Tue, 22 Jul 2014 17:07:14 -0700
Message-ID: <20140723000714.GA5896@samba2>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
 <20140718170952.GA27001@samba2>
 <CAH2r5mubvLEd7QFY8p-YSCojPPdwzQMXK_Ka6k7V0uKRgUeeaw@mail.gmail.com>
 <20140719051427.GA21226@jeremy-HP>
 <CAH2r5mvSEYbGxE166W2GijnhKj4hVcVzhVLJQQeQeWejk4AoaQ@mail.gmail.com>
 <20140721182840.GC29893@samba2>
 <CAH2r5mtLO9jwBx+EumbXzEjiprPMVvnz39CsZJsEm3dAraDDZQ@mail.gmail.com>
 <20140721185528.GD29893@samba2>
 <CAH2r5msV39xCYsK9Ru=zaJadv5-fKa5-DHwUO7wPt+E55k0vMQ@mail.gmail.com>
 <CAH2r5msy4OWaJfAKUrc0Tzx73dsb0zx6fU1wAejKsksq1V8gdA@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msy4OWaJfAKUrc0Tzx73dsb0zx6fU1wAejKsksq1V8gdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 21, 2014 at 02:41:58PM -0500, Steve French wrote:
> To Windows 8.1 it appears to round to 4K boundaries when shrinking but
> also not extend the allocation size when allocating beyond end of file
> as the documentation would imply

You can make Samba do the same as Windows by setting:

allocation roundup size

to 4k.
