From: Arthur Marsh <arthur.marsh-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>
Subject: fs: Limit sys_mount to only request filesystem modules prevents mount
 -t cifs from working
Date: Mon, 11 Mar 2013 23:27:03 +1030
Message-ID: <513DD49F.8010301@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi, I found that Linux kernel 3.9.0-rc2 would not mount a remote cifs 
filesystem, and ran a git bisect which identified the following commit:

am64:/mnt# mount -t cifs //192.168.1.104/homes homes
Password:
am64:/mnt# cd /usr/src/linux
am64:/usr/src/linux# git bisect good
7f78e0351394052e1a6293e175825eb5c7869507 is the first bad commit
commit 7f78e0351394052e1a6293e175825eb5c7869507
Author: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Date:   Sat Mar 2 19:39:14 2013 -0800

     fs: Limit sys_mount to only request filesystem modules.

     Modify the request_module to prefix the file system type with "fs-"
     and add aliases to all of the filesystems that can be built as modules
     to match.

     A common practice is to build all of the kernel code and leave code
     that is not commonly needed as modules, with the result that many
     users are exposed to any bug anywhere in the kernel.

     Looking for filesystems with a fs- prefix limits the pool of possible
     modules that can be loaded by mount to just filesystems trivially
     making things safer with no real cost.

     Using aliases means user space can control the policy of which
     filesystem modules are auto-loaded by editing /etc/modprobe.d/*.conf
     with blacklist and alias directives.  Allowing simple, safe,
     well understood work-arounds to known problematic software.

     This also addresses a rare but unfortunate problem where the filesystem
     name is not the same as it's module name and module auto-loading
     would not work.  While writing this patch I saw a handful of such
     cases.  The most significant being autofs that lives in the module
     autofs4.

     This is relevant to user namespaces because we can reach the request
     module in get_fs_type() without having any special permissions, and
     people get uncomfortable when a user specified string (in this case
     the filesystem type) goes all of the way to request_module.

     After having looked at this issue I don't think there is any
     particular reason to perform any filtering or permission checks beyond
     making it clear in the module request that we want a filesystem
     module.  The common pattern in the kernel is to call request_module()
     without regards to the users permissions.  In general all a filesystem
     module does once loaded is call register_filesystem() and go to sleep.
     Which means there is not much attack surface exposed by loading a
     filesytem module unless the filesystem is mounted.  In a user
     namespace filesystems are not mounted unless .fs_flags = 
FS_USERNS_MOUNT,
     which most filesystems do not set today.

     Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
     Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
     Reported-by: Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
     Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

:040000 040000 32250b65261f4e17804c8af3a106f224dd24bc11 
0cd45f52d550f32b1642281cf1a5d7b94d95f38f M      arch
:040000 040000 9658d1fd413b8797fe06fb2ca8ce681d4dbbedb0 
cd27a1ae4c6ee320ccf6a3872e00f80461325142 M      drivers
:040000 040000 bd510940beafe8c3cd4574da21e7b4acd78d1895 
9785b166b9b4ced468bcc8b6b236bfea42311fbd M      fs
:040000 040000 fa3800a44a3950111115454c47bd30a2db0790e8 
d1bb23380c6c15ef78309d492862f6ca35ce80f2 M      include
:040000 040000 8e24a9945ccff63df12d57cb3fae48e80ce26249 
2e03caba8fa769daed63101e15ef51366cdc9058 M      net
am64:/usr/src/linux#

Is there a patch already present somewhere to fix this problem?

Regards,

Arthur.
