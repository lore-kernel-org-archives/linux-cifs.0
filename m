From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setfacl fix
Date: Sat, 16 Nov 2013 15:38:09 -0600
Message-ID: <CAH2r5mtXjnAOpKzZzta_yWDGyEPzR7h1wb0UW2pnoicm9Qsgxg@mail.gmail.com>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
	<20131116145507.GA22395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131116145507.GA22395-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Makes sense to add a setfacl/getfacl test to xfstest and was trying to
build updated xfstests and look at what has changed but ran into a
strange error building xfstests and didn't see an obvious answer when
googling for it.  Any idea how to workaround the build failure?

Building src
    [DEP]
    [CC]    dirstress
gcc: error: /lib64/libhandle.so: Too many levels of symbolic links


These are the steps I went through from a fairly clean Fedora 19 64
system before the make failure:

git clone git://oss.sgi.com/xfs/cmds/xfstests
git clone git://oss.sgi.com/xfs/cmds/xfsprogs
sudo yum install uuid-devel e2fsprogs-devel libuuid-devel
libattr-devel libacl-devel
cd xfsprogs
make
sudo make install-qa
cd ../xfstests
./configure
make (which failed with the symlink error above)

On Sat, Nov 16, 2013 at 8:55 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Nov 15, 2013 at 08:53:12PM -0600, Steve French wrote:
>> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Date: Fri, 15 Nov 2013 20:41:32 -0600
>> Subject: [PATCH] [CIFS] setfacl removes part of ACL when setting POSIX ACLs to
>>  Samba
>>
>> setfacl over cifs mounts can remove the default ACL when setting the
>> (non-default part of) the ACL and vice versa (we were leaving at 0
>> rather than setting to -1 the count field for the unaffected
>> half of the ACL.  For example notice the setfacl removed
>> the default ACL in this sequence:
>
> Can you send a patch to xfstests to make sure we regression test for
> this issue on all filesystems?
>



-- 
Thanks,

Steve
