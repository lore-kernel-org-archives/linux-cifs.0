From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Mon, 21 Jul 2014 11:55:28 -0700
Message-ID: <20140721185528.GD29893@samba2>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
 <20140718170952.GA27001@samba2>
 <CAH2r5mubvLEd7QFY8p-YSCojPPdwzQMXK_Ka6k7V0uKRgUeeaw@mail.gmail.com>
 <20140719051427.GA21226@jeremy-HP>
 <CAH2r5mvSEYbGxE166W2GijnhKj4hVcVzhVLJQQeQeWejk4AoaQ@mail.gmail.com>
 <20140721182840.GC29893@samba2>
 <CAH2r5mtLO9jwBx+EumbXzEjiprPMVvnz39CsZJsEm3dAraDDZQ@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtLO9jwBx+EumbXzEjiprPMVvnz39CsZJsEm3dAraDDZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 21, 2014 at 01:43:12PM -0500, Steve French wrote:
> What about shrinking the file to the wrong size?

In the set allocation path info it's going through:

        if (allocation_size) {
                allocation_size = smb_roundup(conn, allocation_size);
        }

which by default uses 1MB allocation roundup values.

If you need to set the file length, set the file length :-).

It's arguable if the server can mess with allocation
requests on file shrink, but this hasn't caused a
problem in the SMB1/Windows SMB2 code paths so far,
so I'm guessing it might be allowable....

More research needed !
