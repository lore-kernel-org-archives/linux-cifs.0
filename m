From: Nickolai Zeldovich <nickolai-EfZU8u+QLuPpgkiH4x7ZXw@public.gmane.org>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
Date: Wed, 16 Jan 2013 23:04:33 -0500
Message-ID: <CADGQE7GnR2e-RN6A7iAS1BHCL9odH09z+ds8NdM3bL0hfsLf9A@mail.gmail.com>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu> <CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 16, 2013 at 10:51 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> How did you discover this - did you have an ipv6 test case or by
> inspection or ...?

By mostly-automated inspection (i.e., with the help of a static
program analysis tool).

Nickolai.
