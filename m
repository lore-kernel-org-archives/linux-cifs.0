From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] cifs: potential memory leaks when parsing mnt opts
Date: Sat, 21 Mar 2015 22:54:58 -0500
Message-ID: <CAFB9KM0fDCJ+gHcW0ZyNQdWhraGredJCdBT1AO0GqK4ibFEvYQ@mail.gmail.com>
References: <1426979310-31201-1-git-send-email-tsgatesv@gmail.com>
	<CAFB9KM3==40uUXxxOD_CD09zFPj3Fmr-Brt7x4SZj86NTf3_vg@mail.gmail.com>
	<20150322032340.GD5170@taesoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	sanidhya-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, blee-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, csong84-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
To: Taesoo Kim <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322032340.GD5170-Q1ymHw66ZoYdnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Mar 21, 2015 at 10:23 PM, Taesoo Kim <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org> wrote:
> On 03/21/15 at 09:10pm, Scott Lovenberg wrote:
>> On Sat, Mar 21, 2015 at 6:08 PM, Taesoo Kim <tsgatesv-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > Althouhg mkfs.cifs in userspace performs a bit of sanitization
>> > (e.g., forcing one user option), current implementation is not
>> > robust. Other options such as iocharset and domainanme are similary
>> > vulnerable.
>> >
>>
>> I assume you mean mount.cifs?  :-) Anyways, good catch.
>
> Right. FYI, I've tried mangling password field (e.g., pass=a,user=A
> &c); Skimming through the code (just a few minutes), there are a few
> potential places that don't sanitize its string, unlike passwd. But
> don't have much time to play with for now :)
>
> Thanks,
> Taesoo
>
>> --
>> Peace and Blessings,
>> -Scott.

Without even looking at the code, I can tell you that's probably my
fault if you're talking about the code in mount.cifs.  I was pretty
paranoid about the password field but not so paranoid about the other
parameters.  I'll take a look late tonight or some time tomorrow and
try to patch over my shame. :)

-- 
Peace and Blessings,
-Scott.
