From: Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: Read speed
Date: Mon, 11 Mar 2013 13:54:06 -0400
Message-ID: <513E1A3E.1080404@kickflop.net>
References: <51105F16.8070603@kickflop.net> <CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ@mail.gmail.com> <51113D76.80609@kickflop.net> <20130205142058.7618dfcf@corrin.poochiereds.net> <20130205142307.58d87a21@corrin.poochiereds.net> <5111656C.90109@kickflop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5111656C.90109-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[ suggestion by Jeff Layton to try to ensure that a modern  ]
[ kernel addresses the issues we were seeing over WAN links ]

Just following up.

* Fedora 18 CIFS-over-WAN read performance, as recorded with the same
   testing that was done previously, is ~3.4x that of RHEL 6.3
   (or any common production distro running a pre-3.2 kernel).

So yes, the work done to CIFS addresses our situation directly.
