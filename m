From: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Subject: Re: question about CIFS client glitches
Date: Thu, 16 Sep 2010 20:00:14 -0400
Message-ID: <6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
 <AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com> <AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.
 gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.
 gmail.com>
References: <6.2.5.6.2.20100916171408.03a0fcd8-8QzAbx0zao2B+jHODAdFcQ@public.gmane.org>
 <AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

At 05:50 PM 9/16/2010 -0500, Steve French wrote:
>On Thu, Sep 16, 2010 at 4:39 PM,  <starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org> wrote:
>> Trying out a CIFS mount of a W2K8 x64 file system from CentOS
>> 5.5 and running into problems, and trying to figure out how to
>> proceed.
...
>
>This is quite old kernel, but perhaps it was updated to include more
>recent fixes - can you view the version information on the file, ie
>the cifs.ko module (you can do this by running modinfo on 
>cifs.ko)
>

Thank you for the follow-up.  Per my last message this was my 
being a clueless in regards to the lack of hard/soft link 
support in the old version.  'modinfo' pegs it as 1.60RH.

Hopefully RHEL6 will include CIFS file links as it might work 
better to compile on Linux from a Windows share rather than 
vice-versa.  'makedepend' runs painfully slow from Windows over
a Samba share unless IPoIB is used for transport.

Perhaps I'll try it under Fedora, though in general I find 
wrestling with the constant change of the moving-target distro 
too much.

It is quite encouraging to see CIFS work in general.  Last time 
I tried three or four years ago the system crashed shortly after 
issuing the mount command.
