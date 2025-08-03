# What's up with "Core"?

When you look at the documentation for the [individual components](../content/), you will find that all examples share the same layout, having two root level entries:
`Core` and `<TypeName>`.
E.g.: When modding districts, they are `Core` and `Districts`.

These nodes are _not_ case sensitive, but ... what's up with `Core`?

Example layout:

```powershell
@{
    Core = @{
        # Add some content here
    }
    Districts = @{
        District1 = @{
            # Add some content here
        }
        District2 = @{
            # Add some content here
        }
        DistrictN = @{
            # Add some content here
        }
    }
}
```

Essentially, the `Core` part allows you to define the _default value_ for any setting items of that type support.
For example, adding `BuildTime = 90` to Core, means that every district defined below, that does not define a BuildTime of their own will use that default value (`90`) defined under `Core`.

Updated Example:

```powershell
@{
    Core = @{
        BuildTime = 90
        # Add some content here
    }
    Districts = @{
        District1 = @{
            # Add some content here
        }
        District2 = @{
            BuildTime = 180
            # Add some content here
        }
        DistrictN = @{
            # Add some content here
        }
    }
}
```

In the updated example, _District2_ would have a Build Time of 180, all others one of 90.
