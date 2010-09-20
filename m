From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: [cifs bindaddr v5] cifs: Allow binding to local IP address.
Date: Mon, 20 Sep 2010 10:55:10 -0700
Message-ID: <4C979FFE.7070805@candelatech.com>
References: <1283385962-10539-1-git-send-email-greearb@candelatech.com> <AANLkTimM6CfB8JU0piS74ZMacn8WGVOrcpsWf3OVn7K6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimM6CfB8JU0piS74ZMacn8WGVOrcpsWf3OVn7K6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/20/2010 10:44 AM, Steve French wrote:
> Ben,
> Dr. Holder took a look at this and acked it.
> This does help the problem of choosing
> wired vs. wireless for mounts to specific servers
> (where the default route would be wrong as happened
> to me last week) and also there are some IPv6
> cases it helps with.
>
> If nfs guys require a different name for the mount
> option etc. - let me know.

The NFS guys don't seem to see any use at all in
binding to IPs, so I'm not sure they'll ever take
such a patch.

I should have time to test the smb2 patch today
if all goes well...

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
