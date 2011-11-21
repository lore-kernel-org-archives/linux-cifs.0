From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Mon, 21 Nov 2011 21:24:25 +0530
Message-ID: <4ECA7431.7060101@suse.com>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in> <loom.20111115T070545-916@post.gmane.org> <20111115054504.550248e0@tlielax.poochiereds.net> <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA@mail.linuz.in> <4EC28EB0.6040100@suse.com> <20111116110949.Horde.6gCcWVwlEB5Ow0ylU6mSLSA@mail.linuz.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111116110949.Horde.6gCcWVwlEB5Ow0ylU6mSLSA-i9wRM+HIrml8vCsnxnN6bQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/16/2011 11:09 AM, Aravind M D wrote:
> Quoting Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>:
>>> On 11/15/2011 05:56 PM, Aravind M D wrote:
>>   >> Quoting Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>>   >>
>>   >>> On Tue, 15 Nov 2011 06:07:39 +0000 (UTC)
>>   >>> Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:
>>   >>>
>>   >>>> Aravind M D <aravind@...> writes:
>>   >>>>
>>   >>>>
>>   >>>> >
>>   >>>> > Hi,
>>   >>>> >
>>   >>>> >   I have some cifs mount points configured on my /etc/fstab.
>>   >>>> >
>>   >>>> >   When i am doing mount -a command mount points are mouting
>> again.
>>   >>>> >
> 
> ser2:~ # cat /etc/SuSE-release
> SUSE Linux Enterprise Server 11 (x86_64)
> VERSION = 11
> PATCHLEVEL = 1
> 
> ser2:~ # mount.cifs -V
> mount.cifs version: 1.12-3.4.3-1.17.2-2359-SUSE-CODE11
> 

You might have to use "rpm -qa | grep cifs-mount" to find the version.

Also try upgrading cifs-mount package. "mount -a" mounting cifs mounts
twice atleast  is not reproducible with the recent updates.


-Suresh
