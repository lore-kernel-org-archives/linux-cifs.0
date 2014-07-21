From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setting allocation size in cifs/smb3
Date: Sun, 20 Jul 2014 23:47:53 -0500
Message-ID: <CAH2r5mvSEYbGxE166W2GijnhKj4hVcVzhVLJQQeQeWejk4AoaQ@mail.gmail.com>
References: <CAH2r5ms25+31USEhsfDg7n1tqsF0+bT3qWdwjZ9p2RWEEHuxvQ@mail.gmail.com>
 <20140718170952.GA27001@samba2> <CAH2r5mubvLEd7QFY8p-YSCojPPdwzQMXK_Ka6k7V0uKRgUeeaw@mail.gmail.com>
 <20140719051427.GA21226@jeremy-HP>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140719051427.GA21226@jeremy-HP>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

wireshark trace sent to jra

Also related strange behavior to Samba 4.1.9 ... It is not just that I
see the allocation size not set when I send an allocation size of 5.4M
for a 2M file.  I see the file size shrunk when I sent the request for
a MUCH smaller size.  I sent a request to set allocation size to
length 10000 and the file size of the 2M file (and interestingly also
allocation size) was set to 1MB..

On Sat, Jul 19, 2014 at 12:14 AM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, Jul 18, 2014 at 11:49:04PM -0500, Steve French wrote:
>> Windows shrinks the file (unlike Linux) when you do the allocate
>> before end of file, but when I tried the same call to
>> Samba it seemed to ignore it, return success and leave
>> file size alone.
>
> That's a bug - the code does use ftruncate if
> the new allocated size is less than file size.
>
> Can you send me a wireshark trace of what
> you're sending please ?



-- 
Thanks,

Steve
