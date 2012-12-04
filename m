From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: Remove unused cEVENT macro
Date: Tue, 04 Dec 2012 10:18:44 -0800
Message-ID: <1354645124.6973.16.camel@joe-AO722>
References: <cover.1354217746.git.joe@perches.com>
	 <7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
	 <20121130064710.1bcd227b@tlielax.poochiereds.net>
	 <CAH2r5mtbhZWJu1eoahDSo84Wr=6jrSDVdwEVnQWYxztU72T2nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtbhZWJu1eoahDSo84Wr=6jrSDVdwEVnQWYxztU72T2nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(resending due to bounces, sorry for any inconvenience)

On Fri, 2012-11-30 at 09:39 -0600, Steve French wrote:
> But ... the need still remains for more tracing for cifs (I run into
> this a few times a month at least when debugging) - does anyone have
> any ideas for how to add dynamic trace points to cifs (has anyone even
> done it for the vfs?) - is there any file system that does a good job
> defining dynamic trace points?

I believe ext4 is the only filesystem with significant use of
tracepoints.

Ted? Any tips you care to give as to best implementation methods?
