From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: Re: An odd behavior (win-junction vs. symlink): trying to find why,
 & claim of no-symlinks valid?
Date: Thu, 02 Feb 2017 13:44:03 -0800
Message-ID: <5893A823.8070803@tlinx.org>
References: <589274FE.5070002@tlinx.org> <CAH2r5mvXVX3XZB4kEV-x-sox=E8LmjZ5s00sR3QeE9U78OvHEw@mail.gmail.com> <589299B3.6040604@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <589299B3.6040604-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

L A Walsh wrote:
> Steve French wrote:
>> Have you tried a relative symlink target path (ie ../Program Files)
>> instead of an absolute path?
>>     
----
    Relative links work if the windoes client uses a 'symlinkd', but
but not, it seems, if it is a junction.  FWIW, the other junctions seem
to be using absolute paths.
>> I am puzzled how a junction could work (on Linux) ever - if the target
>> path had C:\... in it or started with \  - on the other hand a target
>> that was relative to the first directory (e.g. began with ..\) should
>> be fine because Linux client could resolve the path.
>>     
----
    The backslashes shown under windows seem to be converted to forward 
slashes
under cygwin and under linux+CIFS.  As for weird directory names (like 
'C:')..
linux supports those.  I have this under my root dir, (this being run on 
linux+CIFS):

>  tree /\?\?
/??
├── C: -> ../athenae
├── D: -> /home/law/Documents
├── M: -> /Share/Music
└── UNC
    ├── Bliss -> Ishtar
    ├── Ishtar
    │   ├── Documents -> /home/Bliss/Documents/law
    │   ├── Music -> /Share/Music
    │   ├── Pictures -> /home/law/Pictures
    │   └── Share -> /Share
    └── ishtar -> Ishtar
-----
    Windows stores volume-based mounts under it's device root, '??'. Then
the drive-colon names are under that, as well as network names under a
dir named UNC. 

    FWIW -- I've always known that at the NT level, NT calls will accept
forward or backward slash as a directory separator.  Most of the Win32 calls
will accept forward slash as well but the newer 'cmd.exe' seems to be more
picky about forward vs. backslash, also seems some of the newer 'NET' 
assemblies
are being more picky.  

    Given that linux+cifs sees those exported paths as having '/' I am
wondering if the NT level really might be using '/' and it's really various
layers on top of that kernel that switch it to a backslash.  It really 
was a
case of Gates wanting his MS-DOS to look sufficiently different from 
CP/M when
he presented it to IBM so they wouldn't wouldn't as easily recognize its
intellectual, and perhaps, physical, antecedents, though NT was developed
completely apart from MS-DOS, in Russia.  They might very well have used '/'
if they developed NT in C, as appears to be the case, though NT uses
N-strings (count+data) instead of Z-strings (or stringZ, w/null 
termination)).

    That's why -- especially in the registry, you can have keys that regedit
or the Win32 calls can't open -- they have embedded nulls in them 
(Sysinternals
used to (maybe still does?) distribute a tool to delete null-containing 
reg-keys (forgive me for repeating things you may already know)...

    Will have to get the trace to you later.  I also had several weird links
on my Winbox to support separate Cywin32 and Cygwin64 installations that 
would
be auto-selected based on the #-of-bits of the calling program, same way
Windows diverted 32-bit apps' references to /Windows/System32 to
/Windows/SysWOW64 on 64-bit systems.  Had to eventually abandon that effort
due to a cygwin bug they refused to fix (they treat some Windows mount 
points as
symlinks because they didn't want to have to deal with circular paths as one
can get on linux).
