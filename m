From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot mount Canon Scanner CIFS share with cifs while smbclient works
Date: Wed, 10 Apr 2013 11:00:21 -0500
Message-ID: <CAH2r5mvrOPFLnpAzB-4WWDopMKjAWsXvSSDbQsL+n3YbT7DHaQ@mail.gmail.com>
References: <20130408194049.GE10949@torres.zugschlus.de>
	<20130410090415.7e1c40b3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130410090415.7e1c40b3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> Steve, weren't you working on a patch to fix the
> client to handle the situation where the server replies
> to the NEGOTIATE with the extended security bit clear?

Yes

> In any case, a workaround for now might be to try and mount with
> sec=none.

Let us know what happens

On Wed, Apr 10, 2013 at 8:04 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 8 Apr 2013 21:40:49 +0200
> Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org> wrote:
>
>> Hi,
>>
>> I own a Canon MX 420 scanner which can scan to a memory card and then
>> offer the scanned information via CIFS. Up to a few kernel versions
>> ago (I think it worked with 3.6, but am not sure about that), things
>> worked just fine and then stopped.
>>
>> The issue is the following:
>>
>> $ sudo mount.cifs  '\\mx420-sch8.local\canon_memory' /media/scanner -o user=anonymous,nounix --verbose
>> Password: <enter>
>> mount.cifs kernel mount options: ip=192.168.218.36,unc=\\mx420-sch8.local\canon_memory,nounix,user=anonymous,pass=********
>> mount error(5): Input/output error
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>
>> A pcap file of the network traffic caused by this command can be
>> downloaded from http://q.bofh.de/~mh/stuff/tcpdump.mount.cifs.
>>
>> Otoh, smbclient '\\mx420-sch8.local\canon_memory' works. A pcap file
>> of the network traffic caused by this command can be downloaded from
>> http://q.bofh.de/~mh/stuff/tcpdump.smbclient.
