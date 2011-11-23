From: Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Wed, 23 Nov 2011 23:30:16 +0530
Message-ID: <CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1111231131100.2111-100000@iolanthe.rowland.org>
	<20111123171245.3e3f18a7@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	NamJae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Unix Support <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, ashishsangwan2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111123171245.3e3f18a7-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Alan,
Ok, translations cannot be added easily. But any idea why surrogate
pairs are not handled? I think handling for surrogate pairs can be
added by identifying proper points(there are not many I guess). Please
share your views.

Regards,
Amit Sahrawat

On Wed, Nov 23, 2011 at 10:42 PM, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> w=
rote:
> On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
>
>> On Wed, 23 Nov 2011, NamJae Jeon wrote:
>>
>> > Hi. Alan.
>> > Would you know why there is no upper/lower case table in nls utf8 =
?
>> > And Currently Surrogate pair is not supported also in nls utf8. Is
>> > there the reason ?
>>
>> I don't know.
>
> For one case translations are locale specific and very very complicat=
ed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
