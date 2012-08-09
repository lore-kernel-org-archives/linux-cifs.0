From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Regression tests for CIFS client
Date: Thu, 09 Aug 2012 20:15:07 +0530
Message-ID: <5023CCF3.8070905@suse.com>
References: <50225505.3080303@suse.com> <20120808084149.26325074@tlielax.poochiereds.net> <CAH2r5mt_ss8YGYLRjQ5dKiRntWCribtScFOtz3hTno6TJQXQqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt_ss8YGYLRjQ5dKiRntWCribtScFOtz3hTno6TJQXQqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/08/2012 07:20 PM, Steve French wrote:
> On Wed, Aug 8, 2012 at 7:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Wed, 08 Aug 2012 17:31:09 +0530
>> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

>>>
>>> The primary intent of the tests is to provide some basic infrastructure
>>> upon which tests can be added easily in the future and these tests are
>>> by no means comprehensive. I have tried to avoid duplicating tests
>>> already done by Connectathon and other tests but there could still be a
>>> few duplicates in there. The tests are only lightly tested.
>>>
>>> Currently cifstests is hosted here:
>>>
>>>    https://github.com/sureshjayaram/cifstests
>>>
>>
>> Sounds like a very worthwhile endeavor. The key to any testing
>> infrastructure is to make it very easy to run the tests. Any hassle in
>> setting it up is a reason not to do so, so you want to make sure there
>> are no such barriers.
>>
>> You also want to make sure that you have the ability to drill down into
>> a single test failure without needing to run a bunch of goop around it.
>> The cthon suite is good for this since most of the tests are written in
>> C. That makes it easy to strace them to track down problems. I assume
>> we'll be able to write tests in C and just have the python framework
>> call them?
> 
> I like the idea of something expandable that we can add tests to (e.g.
> for cifs specific mount options, or to add tests to cover recently
> reported bugs).

Yeah, one of the reasons to keep these tests separate and not adding to
xfstests or other is it, it will give us more flexibility to add CIFS
specific tests without doing a lot of testing on other filesystems.

> I have patches to run xfstests over cifs, but I mostly run
> connectathon and dbench and fsx.  Ideally running regression tests
> could be triggered by commits to a staging tree (or branch of
> cifs-2.6.git) on git.samba.org although not certain how easy this

While that would be ideal, I think if we could run such tests atleast
twice during a release cycle (let's say once during -rc1 and once during
final rc), it would still help us to catch regressions.


Thanks
Suresh
