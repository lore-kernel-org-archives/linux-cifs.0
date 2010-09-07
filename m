From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2: Support srcaddr= logic for smb2 protocol.
Date: Tue, 7 Sep 2010 13:14:01 -0500
Message-ID: <AANLkTi=f+4mwz65TTpFE8RStNpK3foOkrQ7LXLGH=d3m@mail.gmail.com>
References: <4C867495.1030706@candelatech.com>
	<AANLkTims0LH6rJiEOw-CpvSNGbeJoZ7kQmic1E4rehJq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTims0LH6rJiEOw-CpvSNGbeJoZ7kQmic1E4rehJq-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 7, 2010 at 1:08 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> On Tue, Sep 7, 2010 at 12:21 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>=
 wrote:
>>
>> Here's a compile-tested patch to enable srcaddr=3D for smb2.
>>
>> It converts a bit of smb2 to be more like cifs (seems smb2 was copy
>> and pasted and then cifs moved on).
>>
>> It also seems like much of the common code could move to a
>> helper module or something...way too much similarity between
>> cifs and smb2 to have all that duplication.
>
> Yes - the goal is to move to common parsing for (cifs and smb2) ip ad=
dresses and
> five or six other areas. =A0 There was a modest step toward common co=
de
> recently with
> the move of the dns resolver to common code in 2.6.36.

=46orgot to mention that there are differences in SMB2 vs. CIFS in use =
of port 139
(and RFC1001 as well) but shouldn't affect your patch.


--=20
Thanks,

Steve
