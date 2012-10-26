From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs 1.10 to mount share for windows 2008 R2
Date: Fri, 26 Oct 2012 15:43:24 -0400
Message-ID: <CAFB9KM3Htr-B_7JmmqcFAptkg=wqTu6wXmTKqcF7N1ujUtANEw@mail.gmail.com>
References: <mailman.142.1351135138.413883.linux-cifs-client@lists.samba.org>
	<922A2A9451A38A49A39D9B2B2C41465C38F7A89D@KWAWNEXMBP002.corp.root.nasd.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7AA40@KWAWNEXMBP002.corp.root.nasd.com>
	<CADT32eJ9aiasV1Xn25y5mpSn=dhm1B4c9xc+EV0b7wFAv2AsMA@mail.gmail.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7AB87@KWAWNEXMBP002.corp.root.nasd.com>
	<CADT32eLLJko_DJXNE-6fu9r1d7_pfSAcJT0yWE_namVdWNKQkQ@mail.gmail.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7AF4B@KWAWNEXMBP002.corp.root.nasd.com>
	<CADT32eKAkts3_T23t6CUDPOeVCAkA474jq_phZfryUwMV_mDzQ@mail.gmail.com>
	<922A2A9451A38A49A39D9B2B2C41465C38F7B174@KWAWNEXMBP002.corp.root.nasd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Li, Mike" <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <922A2A9451A38A49A39D9B2B2C41465C38F7B174-Ix8smZXprC3zEM4StB/8aAJNPb3QtMV0sHre07pBsdU@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 25, 2012 at 4:14 PM, Li, Mike <Mike.Li-p4uxo6XH8FLYtjvyW6yDsg@public.gmane.org> wrote:
> Shirish,
> Where could mount.cifs 5.7 binaries for RHEL Linux_2.6_x86 be downloaded? Thanks.

Mike, that code was released within the month.  You'll probably have
to clone it from git (git clone git://git.samba.org/cifs-utils.git)
and compile it yourself.  Or, if you have a Red Hat subscription and
if you ask nicely they might* provide you with an RPM.

*I still wouldn't count on it.  They haven't had a chance to test it
in Fedora yet.
-- 
Peace and Blessings,
-Scott.
