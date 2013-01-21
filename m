From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
Date: Mon, 21 Jan 2013 01:41:42 -0600
Message-ID: <CAH2r5mvK6gCqRSh-75a7mqRAH3O-QGvdvhv_VxN1FRxDVv-ctw@mail.gmail.com>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
	<CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
	<CADGQE7GnR2e-RN6A7iAS1BHCL9odH09z+ds8NdM3bL0hfsLf9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nickolai Zeldovich <nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADGQE7GnR2e-RN6A7iAS1BHCL9odH09z+ds8NdM3bL0hfsLf9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Wed, Jan 16, 2013 at 10:04 PM, Nickolai Zeldovich
<nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org> wrote:
> On Wed, Jan 16, 2013 at 10:51 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> How did you discover this - did you have an ipv6 test case or by
>> inspection or ...?
>
> By mostly-automated inspection (i.e., with the help of a static
> program analysis tool).
>
> Nickolai.



-- 
Thanks,

Steve
